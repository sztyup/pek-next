class SvieUser

  def initialize(user)
    @user = user
  end

  def can_join?
    !member? && !in_processing?
  end

  def member?
    @user.svie_member_type != 'NEMTAG'
  end

  def in_processing?
    !@user.svie_post_request.nil?
  end

  def inside_member?
    @user.svie_member_type == 'BELSOSTAG'
  end

  def outside_member?
    @user.svie_member_type == 'KULSOSTAG'
  end

  def inactive_member?
    @user.svie_member_type == 'OREGTAG'
  end

  def can_join_to?(member_type)
    return false if(self.in_processing?) || @user.svie_member_type == member_type
    return !inside_member? if(member_type == 'KULSOSTAG')
    true
  end

  def create_request(member_type)
    unless self.can_join_to?(member_type)
      unauthorized_page
    end
    SviePostRequest.create(user: @user, member_type: member_type)
  end

  def try_inactivate!
    if @user.groups.select {|g| g.issvie?}.nil?
      @user.update(svie_member_type: 'OREGTAG', primary_membership: nil)
    end
  end
end
