function zenity(arg) {
	return "zenity " arg
}

function zenity_html(file, title, other) {
	if (!title) title = gtitle
	if (!other) other = gzenity
	return system(zenity("--text-info --html --filename='" file "' --title='" title "' " other))
}

function zenity_progress(text, title, other) {
	if (!title) title = gtitle
	if (!other) other = gzenity
	return zenity("--progress --title='" title "' --text='" text "' " other)
}

function zenity_alert(type, text, title, other) {
	if (!title) title = gtitle
	if (!other) other = gzenity
	return system(zenity("--" type " --text='" text "' --title='" title "' " other))
}
