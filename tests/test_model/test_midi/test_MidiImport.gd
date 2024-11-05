extends "res://addons/gut/test.gd"
class_name TestMidiImport

var music_importer: MidiExport

func test_import_data():
	var file_exported = FileAccess.open("res://Model/filename.mid", FileAccess.READ)
	#var exported_data = file_exported.get_buffer(file_exported.get_length())  # In the future it will be possible to expand the tests for reading by bits
	assert_true(file_exported != null)
	var exported_data = file_exported.get_as_text()
	file_exported.close()

	var file_imported = FileAccess.open("res://Model/filename.mid", FileAccess.READ) 
	#var imported_data = file_imported.get_buffer(file_imported.get_length())
	assert_true(file_imported != null)
	var imported_data = file_imported.get_as_text()
	file_imported.close()
	
	assert_true(imported_data.length() > 0, "Exported file is empty.")
	assert_string_starts_with(imported_data, "MThd")
	assert_eq(exported_data, imported_data)
