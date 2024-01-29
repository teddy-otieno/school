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

  # Other scopes may use custom stacks.
  # scope "/api", SchoolWeb do
  #   ipe_through :api
  # end

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

    get "/school/dash", SchoolAdministration.SchoolDash.PageController, :home
    get "/school/vendors", SchoolAdministration.SchoolDash.PageController, :vendors
    get "/school/vendors/create", SchoolAdministration.SchoolDash.PageController, :create_vendor
    post "/school/vendors/create", SchoolAdministration.SchoolDash.PageController, :create_vendor
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
end