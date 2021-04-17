class TagPolicy < Struct.new(:user, :tag)
  def show?
    user&.active?
  end
end
