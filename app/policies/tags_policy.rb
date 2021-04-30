class TagsPolicy < Struct.new(:user, :tags)
  def index?
    user&.active?
  end

  def permitted_attributes
    if user.admin?
      [:name, :color]
    else
      []
    end
  end
end
