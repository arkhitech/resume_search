require 'test_helper'

class CompetenciesControllerTest < ActionController::TestCase
  setup do
    @competency = competencies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:competencies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create competency" do
    assert_difference('Competency.count') do
      post :create, competency: { description: @competency.description, name: @competency.name, numeric_weight: @competency.numeric_weight, verbal_weight: @competency.verbal_weight }
    end

    assert_redirected_to competency_path(assigns(:competency))
  end

  test "should show competency" do
    get :show, id: @competency
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @competency
    assert_response :success
  end

  test "should update competency" do
    patch :update, id: @competency, competency: { description: @competency.description, name: @competency.name, numeric_weight: @competency.numeric_weight, verbal_weight: @competency.verbal_weight }
    assert_redirected_to competency_path(assigns(:competency))
  end

  test "should destroy competency" do
    assert_difference('Competency.count', -1) do
      delete :destroy, id: @competency
    end

    assert_redirected_to competencies_path
  end
end
