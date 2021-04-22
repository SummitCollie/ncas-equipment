class TagsPolicy < Struct.new(:user, :tags)
  def index?
    user&.active?
  end
end
