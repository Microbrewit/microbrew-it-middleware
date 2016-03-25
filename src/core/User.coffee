# User utilities
# @author Torstein Thune
# @copyright 2015 Microbrew.it

admins = ['johnfredrik', 'torstein']

convert = (require 'microbrewit-formulas').convert.convert

# Convert to user preferences
# @param [number] value The number to convert
# @param [string] type The type of value
# @param [object] user The user object
# @return [number]
exports.autoConvert = (value, type, user) ->
	unless user
		return value
	return value

# Determine if a user is admin
# @param [Object] user
# @return [Boolean]
exports.isAdmin = (user) ->
	if user.username in admins
		return true
	return false

# Determine if user can edit item
# @param [Object] user The user that you want to check edit priveleges for
# @param [Object] item The item object (any content object like a beer, ingredient, etc.)
# @return [Boolean]
exports.canEdit = (user, item) ->
	if @isAdmin(user)
		return true

	if item.brewers
		for brewer in item.brewers
			console.log "#{user.id} is #{brewer.id}"
			if user.id is brewer.id
				return true

	return false

# Get the user object from the request object
# @param [Object] req The HTTP request object
# @return [Object, Boolean] The user object or false
exports.getUserFromRequest = (req) ->
	return req?.auth?.credentials?.user
	