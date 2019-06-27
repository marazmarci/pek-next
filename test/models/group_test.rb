require 'test_helper'

class GroupTest < ActionController::TestCase
  test 'group is active when newly founded' do
    group = create(:group, :with_additional_info)
    time = Time.new(group.founded)

    Timecop.travel(time) do
      assert_not group.inactive?
    end
  end

  test 'group without evaluation is inactive two years after founded' do
    group = create(:group, :with_additional_info)
    time = Time.new(group.founded + 2)

    Timecop.travel(time) do
      assert group.inactive?
    end
  end

  test 'group with evaluation in last semester is active' do
    evaluation = create(:evaluation)
    group = evaluation.group

    next_semester = Semester.new(evaluation.semester).next!
    allow(SystemAttribute).to receive(:semester).and_return(next_semester)

    assert_not group.inactive?
  end
end
