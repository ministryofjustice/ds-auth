# these are defaults - values set in environment variables can override these
features_enabled = {
  can_only_grant_own_roles: true
}

FeatureFlags::Features.init!(features_enabled)