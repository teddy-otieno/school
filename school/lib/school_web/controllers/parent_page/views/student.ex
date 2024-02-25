defmodule SchoolWeb.ParentPage.Views.Student do
  def index(%{students: students}) do
    %{data: for(student <- students, do: data(student))}
  end

  def show(%{student: student}) do
    %{data: data(student)}
  end

  def data(student) do
    %{id: student.id, first_name: student.first_name, last_name: student.last_name}
  end
end
