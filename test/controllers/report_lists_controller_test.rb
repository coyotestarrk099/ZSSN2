require 'test_helper'

class ReportListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_list = report_lists(:one)
  end

  test "should get index" do
    get report_lists_url, as: :json
    assert_response :success
  end

  test "should create report_list" do
    assert_difference('ReportList.count') do
      post report_lists_url, params: { report_list: { reportedId: @report_list.reportedId, reporterId: @report_list.reporterId } }, as: :json
    end

    assert_response 201
  end

  test "should show report_list" do
    get report_list_url(@report_list), as: :json
    assert_response :success
  end

  test "should update report_list" do
    patch report_list_url(@report_list), params: { report_list: { reportedId: @report_list.reportedId, reporterId: @report_list.reporterId } }, as: :json
    assert_response 200
  end

  test "should destroy report_list" do
    assert_difference('ReportList.count', -1) do
      delete report_list_url(@report_list), as: :json
    end

    assert_response 204
  end
end
