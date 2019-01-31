add_test(NAME test_rectangle
	COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test.py)
set_property( TEST test_rectangle APPEND PROPERTY ENVIRONMENT PYTHONPATH=${CMAKE_BINARY_DIR}/${INSTALL_LIB_DIR}/python )
set_property( TEST test_rectangle APPEND PROPERTY DEPENDS pyrectangle )