class QuestionGroupsController < ApplicationController

  def new
    @title = "Add Question"
    @survey_section_id = params[:survey_section_id]
    @question_group = QuestionGroup.new(text: params[:text])
    @question_group.questions.build(display_order: params[:display_order])
  end


  def edit
    @title = "Edit Question Group"
    @question_group = QuestionGroup.includes(:questions).find(params[:id])
    @survey_section_id = @question_group.questions.first.survey_section_id
  end

  def create
    @question_group = QuestionGroup.new(question_group_params)
    if @question_group.save
      #@question_group.questions.update_attributes(survey_section_id: question_group_params[])
      render :inline => '<div id="cboxQuestionId">'+@question_group.questions.first.id.to_s+'</div>', :layout=>'colorbox'
    else
      @title = "Add Question"
      survey_section_id = question_group_params[:survey_section_id]
      redirect_to :action => 'new', :controller => 'questions', :layout=>'colorbox', :survey_section_id => survey_section_id
    end
  end

  def update
    @title = "Update Question"
    @question_group = QuestionGroup.includes(:questions).find(params[:id])
    if @question_group.update_attributes(question_group_params)
      render :blank, :layout=>'colorbox'
    else
      render :action => 'edit', :layout=>'colorbox'
    end
  end

  def render_group_inline_partial
    @question_group = QuestionGroup.find(params[:id])
    if params[:add_row]
      
      @question_group = QuestionGroup.new
      @question_group.questions.build(display_order: params[:display_order])
      render :partial => 'group_inline_field'
    else
      render :partial => 'group_inline_fields'
    end
  end
  private
  def question_group_params
    ::PermittedParams.new(params[:question_group]).question_group
  end
end
