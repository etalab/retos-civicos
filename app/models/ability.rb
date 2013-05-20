class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 

    can [:edit, :update, :define_role, :set_role], User do |u| 
      user.id == u.id
    end


    if user.organization?
      #Challenge access
      can [:new, :create], Challenge
      can [:edit, :update, :cancel], Challenge do |challenge|
        challenge.organization.id == user.userable.id
      end

      #Comment access
      can [:like], Comment do |comment|
        comment.user.id != user.id && !user.voted_on?(comment)
      end

      #Organization access
      can [:edit, :update], Organization do |organization|
        organization.id == user.userable.id
      end

      can [:create, :reply], Comment 
      can [:like], Challenge
    end

    if user.member?
      #Challenge access
      can [:like], Challenge

      #Collaboration access
      can [:create], Collaboration

      #Members access
      can [:edit, :update], Member do |member|
        user.userable.id == member.id
      end

      #Comment access
      can [:like], Comment do |comment|
        comment.user.id != user.id && !user.voted_on?(comment)
      end

      #Comment creation for members, restricting access through challenge
      can [:create_or_reply_challenge_comment], Challenge do |challenge|
        user.collaborating_in? challenge
      end
    end
  end
end