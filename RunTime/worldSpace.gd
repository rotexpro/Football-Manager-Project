extends Node

# Grid drawn out on the field
var grid

# Players playing on the field
var matchPlayers 

# Center position from the field
var CENTER_POSITION

# Match start boolean
var matchStart:bool = false

# Actual field ball object
var ball

# Away goal position
var awayGoal

# Field width positions
var FIELD_WIDTH_START
var FIELD_WIDTH_END

# Field height positions
var FIELD_HEIGHT_TOP
var FIELD_HEIGHT_BOTTOM

# Field calculated positions
var FIELD_WIDTH
var FIELD_HEIGHT

# List of field positions
var HOME_POSITIONS
var AWAY_POSITIONS

# Goal keeper line positions
var GOAL_KEEPER_LINE_TOP
var GOAL_KEEPER_LINE_BOTTOM
