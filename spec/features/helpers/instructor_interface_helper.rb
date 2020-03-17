module InstructorInterfaceHelper
  def self.set_deadline_type
    create(:deadline_type, name: "submission")
    create(:deadline_type, name: "review")
    create(:deadline_type, name: "metareview")
    create(:deadline_type, name: "drop_topic")
    create(:deadline_type, name: "signup")
    create(:deadline_type, name: "team_formation")
  end

  def self.set_deadline_right
    create(:deadline_right)
    create(:deadline_right, name: 'Late')
    create(:deadline_right, name: 'OK')
  end

  def self.set_assignment_due_date
    create(:assignment_due_date)
    create(:assignment_due_date, deadline_type: DeadlineType.where(name: 'review').first, due_at: Time.now.in_time_zone + 1.day)
  end

  def self.assignment_setup
    create(:assignment)
    create_list(:participant, 3)
    create(:assignment_node)
    set_deadline_type
    set_deadline_right
    set_assignment_due_date
  end

  def self.course_setup
    create(:course)
    create_list(:participant, 3)
    create(:course_node)
  end

  def self.import_topics(filepath)
    login_as("instructor6")
    visit '/assignments/1/edit'
    click_link "Topics"
    click_link "Import topics"
    file_path = Rails.root + filepath
    attach_file('file', file_path)
    click_button "Import"
    click_link "Topics"
  end

  def self.expect_page_content_to_have(content, has_content)
    content.each do |content_element|
      if has_content
        expect(page).to have_content(content_element)
      else
        expect(page).not_to have_content(content_element)
      end
    end
  end

  def self.validate_login_and_page_content(filepath, content, has_content)
    import_topics(filepath)
    expect_page_content_to_have(content, has_content)
  end
end
