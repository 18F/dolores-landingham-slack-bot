class EmployeesController < ApplicationController
  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)

    if unknown_employee(@employee.slack_username)
      flash.now[:error] = "There is not a slack user with the username \"#{@employee.slack_username}\" in your organization."
      render action: :new
    elsif @employee.save
      flash[:notice] = "Thanks for adding #{@employee.slack_username}"
      redirect_to root_path
    else
      flash.now[:error] = "Could not create employee"
      render action: :new
    end
  end

  def index
    @employees = Employee.order(started_on: :desc)
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])

    if unknown_employee(params[:employee][:slack_username])
      flash.now[:error] = "There is not a slack user with the username \"#{params[:employee][:slack_username]}\" in your organization."
      render action: :edit
    elsif @employee.update(employee_params)
      flash[:notice] = "Employee updated successfully"
      redirect_to employees_path
    else
      flash.now[:error] = "Could not update employee"
      render action: :edit
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:slack_username, :started_on)
  end

  def unknown_employee(slack_username)
    !EmployeeFinder.new(slack_username).existing_employee?
  end
end
