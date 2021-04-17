class TagPolicy < Struct.new(:user, :tag)
  def index?
    user&.active?
  end
end
