class Api::V1::ArkSerializer < Api::V1::BaseSerializer
  attributes :id, :who, :what, :when, :where

  def id
    object.identifier
  end

end