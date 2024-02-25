defmodule SchoolWeb.ParentPage.Views.FindChildView do
  alias School.School.Student
  alias School.School

  def index(%{result: results}) do
    IO.inspect(results)
    %{data: for(item <- results, do: data(item))}
  end

  def data({%School{} = school, %Student{} = student}) do
    %{
      student_id: student.id,
      school_name: school.name,
      student_name: student.first_name <> " " <> student.last_name
    }
  end
end
