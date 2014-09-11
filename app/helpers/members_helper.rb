module MembersHelper
  def member_path2(member)
    member_path(member_params(member))
  end

  def member_policy_path2(member, policy)
    member_policy_path(member_params(member).merge(dmp: policy.id))
  end

  def full_member_policy_path2(member, policy)
    full_member_policy_path(member_params(member).merge(dmp: policy.id))
  end

  def votes_member_path2(member)
    votes_member_path(member_params(member))
  end

  def friends_member_path2(member)
    friends_member_path(member_params(member))
  end

  def member_params(member)
    {
      mpn: member.url_name.downcase,
      mpc: member.url_electorate.downcase,
      house: member.australian_house
    }
  end

  def vote_class(vote)
    if vote.nil?
      ""
    elsif vote.rebellion?
      "rebel"
    else
      ""
    end
  end

  def member_type_party_place_sentence(member)
    # TODO: if not a senator, add the state after the electorate. e.g. Goldstein, Vic
    if member.currently_in_parliament?
      text = member.party_long + " " + member_type(member.australian_house) + " for " +
        content_tag(:span, member.electorate, class: "electorate")
    else
      text = "Former " + member.party_long + " " + member_type(member.australian_house) + " for " +
        content_tag(:span, member.electorate, class: 'electorate')
    end
    text.html_safe
  end

  def member_type_place_sentence(member)
    # TODO: if not a senator, add the state after the electorate. e.g. Goldstein, Vic
    if member.currently_in_parliament?
      text = member_type(member.australian_house) + " for " +
        content_tag(:span, member.electorate, class: "electorate")
    else
      text = "Former " + member_type(member.australian_house) + " for " +
        content_tag(:span, member.electorate, class: 'electorate')
    end
    text.html_safe
  end

  def member_type_place_date_sentence(member)
    text = member_type_place_sentence(member)
    if member.currently_in_parliament?
      text += (" " +
        content_tag(:span, "since #{member.since}", class: 'member-period')).html_safe
    else
      text += (", " +
        content_tag(:span, "#{member.since} – #{member.until}", class: 'member-period')).html_safe
    end
    text
  end
end
