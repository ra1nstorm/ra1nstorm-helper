function zenity(arg,\
	usr,usra) {
	# Don't run zenity as root anymore
	if (ENVIRON["HOME"] ~ /\/home\//) {
		split(ENVIRON["HOME"], usra, "/")
		usr = usra[3]
	} else {
		usr = "nobody"
	}
	return "sudo -u "usr" zenity " arg
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

function zenity_radiolist(choices, text, title, other,\
	cmd,charr,charr2,opt,status) {
	if (!title) title = gtitle
	if (!other) other = gzenity
	cmd = zenity("--list --radiolist --title '"title"' --text '"text"' "other" --hide-header --column A --column B ")
	split(choices, charr, ";")
	for (i in charr) {
		charr2[charr[i]] = i
		cmd = cmd " FALSE '" charr[i] "'"
	}
	cmd | getline opt
	status = close(cmd)
	if (status != 0) return ""
	return charr2[opt]
}
