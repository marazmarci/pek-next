class GroupsController < ApplicationController
  before_action :require_login
  before_action :before_action_init, only: [:show]

  def before_action_init
    @group = Group.find(params[:id])
    @is_member = MembershipController.new.is_member(@group.id, current_user.id)
    @is_leader = MembershipController.new.is_leader(@group.id, current_user.id)
  end

  # GET /groups
  def index
    @groups = Group.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /groups/:id
  def show
    @memberships = GrpMembership.where(grp_id: @group.id, membership_end: nil)
    @members = []
    @memberships.each do |m|
      @members.push(User.find(m.usr_id))
    end
    @posts = []
    @memberships.each_with_index do |m, index|
      posts = Poszt.where(grp_member_id: m.id)
      @posts.push([])
      posts.each do |p|
        @posts[index].push(Poszttipus.find(p.pttip_id))
      end
    end
  end
end
