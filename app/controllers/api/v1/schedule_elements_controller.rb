# == Schema Information
#
# Table name: schedule_elements
#
#  id          :integer          not null, primary key
#  schedule_id :integer
#  section_id  :integer
#  collision   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Api::V1::ScheduleElementsController < Api::V1::AuthsController
include ScheduleElementsHelper
include SchedulesHelper
include CoursesHelper


  ## BEGIN CREATION

  # Used to validate creation
  before_action :schedule_belongs_to_user, only: [:create, :destroy]
  before_action :proper_term, only: [:create]


  # Check to see if the schedule exists/belongs to the user  (used in specific subclasses)
  def schedule_belongs_to_user
    @schedule = Schedule.find_by(id: schedule_element_params[:schedule_id], user_id: @user.id)
    if @schedule.blank?
      render json: { success: false, data: { errors: ["This schedule either doesn't exist or doesn't belong to you"] } }
    else
      @schedule
    end
  end


  # Cascading validations for creation
  def proper_term
    if schedule_element_params[:term] != @schedule.term
      render json: { success: false, data: { errors: ["This schedule's term does not match the desired course's term"]}} and return
    end
    @schedule
  end


  # Create a schedule element and load the DB accordingly
  def create
    sections = schedule_element_params[:section_num]
    schedule_elmts = []
    @course = Course.find_by(crse_id: schedule_element_params[:crse_id],
      term: schedule_element_params[:term])

    # Grab required creds
    term = schedule_element_params[:term]
    subject = schedule_element_params[:subject]
    number = schedule_element_params[:number].to_i


    # If the course is blank, make the course + all sections
    if @course.blank?
      course_info = get_course_info(term, subject, number)
      @course = build_course_and_sections(course_info, term)[0]
    end

    # [CS1110_LEC, CS1110_DIS].each do ..
    sections.each do |sn|
      @section = Section.find_by(course_id: @course.id, section_num: sn)
      if @section.blank?
        render json: { success: false, data: { errors: ["This section does not exist within this course"] }} and return
      end
      @se = @schedule.schedule_elements.create(section_id: @section.id, subject: subject, catalog_number: number)
      if @se.valid?
        update_se_collisions(@schedule)
      end
      data = @se.valid? ? schedule_element_json(@se) : { errors: @se.errors.full_messages }
      if !@se.valid?
        render json: { success: false, data: data } and return
      else
        schedule_elmts << data["schedule_element"]
      end
    end
    render json: { success: true, data: schedule_json(@schedule) }

  end


  # Delete a schedule element from a specific schedule
  def destroy
    schedule_element_ids = schedule_element_params[:id]
    success = true
    schedule_element_ids.each do |se_id|
      @schedule_element = @schedule.schedule_elements.find_by(id: se_id)
      @schedule_element.destroy
      if !@schedule_element.blank?
        update_se_collisions(@schedule)
      end
      success = success && !@schedule_element.blank?
    end
    # Re-request for the sake of data consistency
    @schedule = Schedule.find_by(id: schedule_element_params[:schedule_id], user_id: @user.id)
    render json: { success: success, data: schedule_json(@schedule) }
  end


  private

    # Schedule Element Safe Params
    def schedule_element_params(extra={})
      if params[:schedule_element].present?
        params[:schedule_element][:id] ||= [] # To ensure array structure
        params[:schedule_element][:section_num] ||= [] # To ensure array structure
        params.require(:schedule_element).permit(:schedule_id, :term, :crse_id, :subject, :number, id: [], section_num: []).merge(extra)
      else
        {}
      end
    end



end
