class CurrentUserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :roles
end
