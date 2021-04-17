class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def create?
    user.admin?
  end

  def new?
    user.admin?
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin?
  end

  class Scope
    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, 'must be logged in' unless user
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
