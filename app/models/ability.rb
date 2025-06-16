class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, Subject

    if user.supervisor?
      can :manage, :all
      cannot :take_exam, UserExam
      cannot :create, UserExam
      cannot :submit_answers, UserExam
    elsif user.user?
      can :read, UserExam, user_id: user.id
      can :create, UserExam
      can :take_exam, UserExam
      can :submit_answers, UserExam, user_id: user.id
    end
  end
end
