class Api::V1::ArkSerializer < Api::V1::BaseSerializer
  attributes :identifier, :who, :what, :when, :where
end