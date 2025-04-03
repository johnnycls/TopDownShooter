extends CanvasLayer

var page: Control

func popup(_page: Control) -> void:
	if page == null:
		page = _page
		add_child(page)
		if page.has_signal("close"):
			page.close.connect(close_popup)
	
func close_popup() -> void:
	page.queue_free()
	page = null
