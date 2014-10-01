class PoliciesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :detail, :full]

  def index
    @policies = Policy.order(:private, :name).includes(divisions: :wiki_motions)
  end

  def show
    @policy = Policy.find(params[:id])

    if params[:mpc] && params[:mpn]
      electorate = params[:mpc].gsub("_", " ")
      name = params[:mpn].gsub("_", " ")

      @member = Member.with_name(name)
      @member = @member.in_australian_house(params[:house])
      @member = @member.where(constituency: electorate)
      @member = @member.order(entered_house: :desc).first

      if @member
        # Pick the member where the votes took place
        @member = @member.person.member_for_policy(@policy)
        render "show_with_member"
      else
        render 'members/member_not_found', status: 404
      end
    end
  end

  def full
    electorate = params[:mpc].gsub("_", " ")
    name = params[:mpn].gsub("_", " ")

    @member = Member.with_name(name)
    @member = @member.in_australian_house(params[:house])
    @member = @member.where(constituency: electorate)
    @member = @member.order(entered_house: :desc).first

    if @member
      @policy = Policy.find(params[:id])
      # Pick the member where the votes took place
      @member = @member.person.member_for_policy(@policy)
      render "full"
    else
      render 'members/member_not_found', status: 404
    end
  end

  def detail
    @policy = Policy.find(params[:id])
  end

  def edit
    @policy = Policy.find(params[:id])
  end

  def new
    @policy = Policy.new
  end

  def create
    if params[:commit] == 'Make Policy'
      @policy = Policy.new name: params[:policy][:name], description: params[:policy][:description], user: current_user, private: 2
      if @policy.save
        redirect_to @policy, notice: 'Successfully made new policy'
      else
        flash[:alert] = 'Creating a new policy not complete, please try again'
        render 'new'
      end
    else
      redirect_to policies_path
    end
  end

  def update
    @policy = Policy.find(params[:id])

    if params[:submit] == 'Save title and text'
      if @policy.update name: params[:name], description: params[:description], private: (params[:provisional] ? 2 : 0)
        redirect_to @policy, notice: 'Policy updated.'
      else
        redirect_to edit_policy_path(@policy), alert: 'Could not update policy.'
      end
    else
      redirect_to @policy
    end
  end

  def history
    @policy = Policy.find(params[:id])
  end
end
