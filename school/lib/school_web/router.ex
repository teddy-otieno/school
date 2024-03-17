defmodule SchoolWeb.Router do
  use SchoolWeb, :router

  import SchoolWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SchoolWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SchoolWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/signup", SignupPage.PageController, :home
    post "/signup", SignupPage.PageController, :handle_signup
    get "/login", LoginPage.PageController, :home
    post "/login", LoginPage.PageController, :login
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:school, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SchoolWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SchoolWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SchoolWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SchoolWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/parent", ParentPage.PageController, :home

    # live_session :require_authenticated_user,
    #   on_mount: [{SchoolWeb.UserAuth, :ensure_authenticated}] do
    #   live "/users/settings", UserSettingsLive, :edit
    #   live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    # end
  end

  scope "/", SchoolWeb do
    pipe_through [:browser, :require_authenticated_user, :require_school_user]

    get "/school/setup", SchoolAdministration.SchoolSetup.PageController, :home
    post "/school/setup", SchoolAdministration.SchoolSetup.PageController, :setup
    get "/school/classes", SchoolAdministration.SchoolSetup.PageController, :classes
    get "/school/classes/create", SchoolAdministration.SchoolSetup.PageController, :create_class
    get "school/classes/students/:class_id", SchoolAdministration.SchoolDash.ClassesController, :list_students

    get "/school/dash", SchoolAdministration.SchoolDash.PageController, :home
    get "/school/vendors", SchoolAdministration.SchoolDash.PageController, :vendors
    get "/school/vendors/create", SchoolAdministration.SchoolDash.PageController, :create_vendor
    post "/school/vendors/create", SchoolAdministration.SchoolDash.PageController, :create_vendor
    get "/school/vendors/:vendor_id", SchoolAdministration.SchoolDash.PageController, :view_vendor_profile
    get "/school/students", SchoolAdministration.SchoolDash.PageController, :students
    get "/school/students/create", SchoolAdministration.SchoolDash.PageController, :create_student
    get "/school/parents", SchoolAdministration.SchoolDash.PageController, :index_parents

    post "/school/students/create",
         SchoolAdministration.SchoolDash.PageController,
         :create_student
  end

  scope "/", SchoolWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    # live_session :current_user,
    #   on_mount: [{SchoolWeb.UserAuth, :mount_current_user}] do
    #   live "/users/confirm/:token", UserConfirmationLive, :edit
    #   live "/users/confirm", UserConfirmationInstructionsLive, :new
    # end
  end

  # Other scopes may use custom stacks.
  scope "/api", SchoolWeb do
    pipe_through :api

    post "/parents/signup", ParentPage.PageController, :signup
    post "/login", LoginPage.PageController, :mobile_login
  end

  pipeline :api_auth do
    plug School.AuthAccessPipeline
  end

  scope "/api/parents", SchoolWeb do
    pipe_through [:api, :api_auth, :require_parent_auth]

    get "/students", ParentPage.StudentsController, :index
    post "/students/find_child", ParentPage.StudentsController, :find_child
    get "/students/assign/:student_id", ParentPage.StudentsController, :assign_to_parent
    get "/students/:student_id", ParentPage.StudentsController, :view_student_profile

    get "/students/transactions/:student_id",
        ParentPage.FinanceController,
        :list_recent_transactions

    post "/deposit", ParentPage.FinanceController, :deposit
  end

  scope "/api/vendors", SchoolWeb do
    pipe_through [:api, :api_auth, :require_vendor_auth]

    resources "/products", Vendors.ProductPageController, except: [:create]
    get "/stock/product", Vendors.StocksController, :list_all_products_with_quantities
    resources "/stock", Vendors.StocksController
    resources "/sales", Vendors.SalesController
  end

  pipeline :form_data_with_token_auth do
    plug School.AuthAccessPipeline
    plug Plug.Parsers, parsers: [:urlencoded, {:multipart, length: 20_000_000}]
  end

  scope "/", SchoolWeb do
    pipe_through [:api]
    get "/media/:path/:file", MediaController, :show
  end

  scope "/api/vendors", SchoolWeb do
    pipe_through [:api, :form_data_with_token_auth]

    resources "/products", Vendors.ProductPageController, only: [:create]
  end
end
