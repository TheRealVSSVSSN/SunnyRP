SRP_CONST = SRP_CONST or {}

SRP_CONST.BUCKET = {
  LOADING    = 1,
  MAIN       = 2,
  CHAR_START = 10001,
  CHAR_COUNT = 1000,
  ADMIN_START= 50001
}

SRP_CONST.EVENTS = {
  HUD_SET      = 'srp:ui:hud:set',
  WORLD_TIME   = 'srp:world:time',
  WORLD_WEATHER= 'srp:world:weather',
  IPL_ENSURE   = 'srp:ipl:ensure',
  IPL_REMOVE   = 'srp:ipl:remove',
  SPAWN_CHOOSE = 'srp:spawn:choose'
}

SRP_CONST.SCOPES = {
  STAFF_ANY    = 'staff:*',
  ADMIN_FLAGS  = 'admin:flags',
  ADMIN_BUCKET = 'admin:bucket',
  ADMIN_WORLD  = 'admin:world'
}