##
# Class to handle the API calls in the application for minting and updating ARKs
#
# Usage:
#   GET api/v1/mint
#     Mints a new ARK identifier and returns it.
#     Request Header: api-key
#     Response format: JSON
#     Status Code: 200
#   POST api/v1/mint
#     Mints a new ARK identifier and returns it.
#     Request Header: api-key
#     Response format: JSON
#     Status Code: 200
#     Parameters:
#       - who
#       - what
#       - when
#       - where
#   GET api/v1/id/ark:/{ark identifier}
#     Returns the erc for the given ark identifier
#     Response format: JSON
#     Status Code: 200
#   PUT api/v1/id/ark:/{ark identifier}
#     Updates the erc for the given ark identifier
#     Request Header: api-key
#     Response format: JSON
#     Status Code: 200
#     Parameters:
#       - who
#       - what
#       - when
#       - where
#   DELETE api/v1/id/ark:/{ark identifier}
#     Destorys the given ark identifier
#     Request Header: api-key
#     Status Code: 204
#
class Api::V1::ArksController < Api::V1::BaseController
  before_action :authenticate_request!, only: [:mint, :update, :destroy]

  def mint
    if Settings.naan.nil? or Settings.naan.empty?
      return api_error(status: 500, errors: 'Missing NAAN in server configuration')
    end

    sleep(rand(15) / 10.0) while WithLocking.locked?("minting")

    id = ''
    WithLocking.run(name: "minting") do
      minter = Noid::Minter.new(read_state(params[:prefix]))
      id = "ark:/" + Settings.naan + "/" + minter.mint
      write_state minter.dump
    end
    api_error(status: 500, errors: "Unable to mint new ark") if id.blank?

    logger.debug("Minted id #{id}")

    ark = Ark.new({ :identifier => id })
    if request.post?
      ark.update_attributes(ark_params)
    end

    begin
      ark.save!
    rescue ActiveRecord::RecordInvalid => e
      return api_error(status: 500, errors: "Unable to save new identifier: #{e}")
    end
    render(json: { id: id }.to_json)
  end

  def show
    ark = Ark.find_by(identifier: params[:id]) or return not_found

    render(json: Api::V1::ArkSerializer.new(ark).to_json)
  end

  def update
    ark = Ark.find_by(identifier: params[:id]) or return not_found

    if !ark.update_attributes(ark_params)
      return api_error(status: 422, error: ark.errors)
    end

    render(
      json: Api::V1::ArkSerializer.new(ark),
      status: 200,
      location: api_v1_ark_path(params[:id])
    )
  end

  def destroy
    ark = Ark.find_by(identifier: params[:id]) or return not_found

    if !ark.destroy
      return api_error(status: 500)
    end

    head status: 204
  end

  private

    def ark_params
      params.permit(:where, :what, :when, :who)
    end

    def read_state(prefix = '')
      begin
        ms = MinterState.where(prefix: prefix.to_s)
        state = Marshal.load(ms.state)
      rescue => e
        logger.warn "Unable to read state file: #{e}"
        state = { template: prefix.to_s + Settings.noid_template }
      rescue Exception => e
        logger.warn "Unable to read state file: #{e}"
      end

      return state
    end

    def write_state(state)
      prefix = /(.*)\.[rszedk]+/.match(state[:template])[1]

      begin
        ms = MinterState.where(prefix: prefix.to_s).first_or_create do |ms|
          ms.template = state[:template]
        end
        ms.state = Marshal.dump(state)
        ms.save
      rescue ActiveRecord::RecordInvalid => e
        logger.warn "Unable to save state: #{e}"
      end
    end

end
