exports.gravatar = (email = 'lol', size = '22') ->
	return "<div class="avatar gravatar"><img src="{{url}}" style="width:{{size}};height:{{size}}" alt="" /></div>"

emailToGravatar = (email) ->