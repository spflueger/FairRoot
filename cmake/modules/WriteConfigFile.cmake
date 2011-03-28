MACRO (WRITE_CONFIG_FILE filename)

  IF(${filename} MATCHES "[.]csh")
    SET(CSH_OUT TRUE)
  ELSE(${filename} MATCHES "[.]csh")
    SET(CSH_OUT FALSE)
  ENDIF(${filename} MATCHES "[.]csh")

  SET(FAIRLIBDIR ${CMAKE_CURRENT_BINARY_DIR}/lib)
  
  IF(CMAKE_SYSTEM_NAME MATCHES Linux)
#    SET(LD_LIBRARY_PATH ${FAIRLIBDIR} ${LD_LIBRARY_PATH} /usr/lib /usr/X11R6/lib ) 
    SET(LD_LIBRARY_PATH ${FAIRLIBDIR} ${LD_LIBRARY_PATH}) 
  ELSE(CMAKE_SYSTEM_NAME MATCHES Linux)
    IF(CMAKE_SYSTEM_NAME MATCHES Darwin)
      SET(LD_LIBRARY_PATH ${FAIRLIBDIR} ${LD_LIBRARY_PATH})
    ENDIF(CMAKE_SYSTEM_NAME MATCHES Darwin)
  ENDIF(CMAKE_SYSTEM_NAME MATCHES Linux)
  

  configure_file(${PROJECT_SOURCE_DIR}/cmake/scripts/check_system.sh.in
                   ${CMAKE_CURRENT_BINARY_DIR}/check_system.sh
                  )

  IF(CMAKE_SYSTEM_NAME MATCHES Linux)
    FILE(READ /etc/issue _linux_flavour)
    STRING(REGEX REPLACE "[\\]" " " _result1 "${_linux_flavour}")
    STRING(REGEX REPLACE "\n" ";" _result "${_result1}")
    SET(_counter 0)
    FOREACH(_line ${_result})
      if (_counter EQUAL 0)
        SET(_counter 1)
        set(_linux_flavour ${_line})
      endif (_counter EQUAL 0)
    ENDFOREACH(_line ${_result})
    EXECUTE_PROCESS(COMMAND uname -m 
                    OUTPUT_VARIABLE _system 
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                   )
   
    WRITE_TO_FILE(${filename} Linux_Flavour_ ${_linux_flavour} "")
    WRITE_TO_FILE(${filename} System_ ${_system} APPEND)
    WRITE_FILE(${filename} ". ${CMAKE_CURRENT_BINARY_DIR}/check_system.sh" APPEND)
    WRITE_FILE(${filename} " if [ \"$same_system\" == \"1\" ]; then" APPEND)
  ENDIF(CMAKE_SYSTEM_NAME MATCHES Linux)


  WRITE_TO_FILE(${filename} SIMPATH ${SIMPATH} APPEND) 
  WRITE_TO_FILE(${filename} ROOTSYS ${ROOTSYS} APPEND) 

  IF (GEANT4_FOUND AND GEANT4VMC_FOUND AND CLHEP_FOUND)
    CONVERT_LIST_TO_STRING(${GEANT4_LIBRARY_DIR})
    WRITE_TO_FILE(${filename} GEANT4_LIBRARY_DIR ${output} APPEND)

    CONVERT_LIST_TO_STRING(${GEANT4_INCLUDE_DIR})
    WRITE_TO_FILE(${filename} GEANT4_INCLUDE_DIR ${output} APPEND)
 
    CONVERT_LIST_TO_STRING(${GEANT4VMC_INCLUDE_DIR})
    WRITE_TO_FILE(${filename} GEANT4VMC_INCLUDE_DIR ${output} APPEND)
 
    CONVERT_LIST_TO_STRING(${GEANT4VMC_LIBRARY_DIR})
    WRITE_TO_FILE(${filename} GEANT4VMC_LIBRARY_DIR ${output} APPEND)

    CONVERT_LIST_TO_STRING(${GEANT4VMC_MACRO_DIR})
    WRITE_TO_FILE(${filename} GEANT4VMC_MACRO_DIR ${output} APPEND)

    CONVERT_LIST_TO_STRING(${CLHEP_INCLUDE_DIR})
    WRITE_TO_FILE(${filename} CLHEP_INCLUDE_DIR ${output}  APPEND)

    CONVERT_LIST_TO_STRING(${CLHEP_LIBRARY_DIR})
    WRITE_TO_FILE(${filename} CLHEP_LIBRARY_DIR ${output} APPEND)
  ENDIF (GEANT4_FOUND AND GEANT4VMC_FOUND AND CLHEP_FOUND) 
  
  CONVERT_LIST_TO_STRING(${PLUTO_LIBRARY_DIR})
  WRITE_TO_FILE(${filename} PLUTO_LIBRARY_DIR ${output} APPEND)

  CONVERT_LIST_TO_STRING(${PLUTO_INCLUDE_DIR})
  WRITE_TO_FILE(${filename} PLUTO_INCLUDE_DIR ${output} APPEND)

  CONVERT_LIST_TO_STRING(${PYTHIA6_LIBRARY_DIR})
  WRITE_TO_FILE(${filename} PYTHIA6_LIBRARY_DIR ${output} APPEND)

  CONVERT_LIST_TO_STRING(${GEANT3_SYSTEM_DIR})
  WRITE_TO_FILE(${filename} G3SYS ${output} APPEND)

  CONVERT_LIST_TO_STRING(${GEANT3_INCLUDE_DIR})
  WRITE_TO_FILE(${filename} GEANT3_INCLUDE_DIR ${output} APPEND)

  CONVERT_LIST_TO_STRING(${GEANT3_LIBRARY_DIR})
  WRITE_TO_FILE(${filename} GEANT3_LIBRARY_DIR ${output} APPEND)

  CONVERT_LIST_TO_STRING(${GEANT3_LIBRARIES})
  WRITE_TO_FILE(${filename} GEANT3_LIBRARIES ${output} APPEND)

  CONVERT_LIST_TO_STRING(${ROOT_LIBRARY_DIR})
  WRITE_TO_FILE(${filename} ROOT_LIBRARY_DIR ${output} APPEND)

  CONVERT_LIST_TO_STRING(${ROOT_LIBRARIES})
  WRITE_TO_FILE(${filename} ROOT_LIBRARIES ${output} APPEND)

  CONVERT_LIST_TO_STRING(${ROOT_INCLUDE_DIR})
  WRITE_TO_FILE(${filename} ROOT_INCLUDE_DIR ${output}  APPEND)

  WRITE_TO_FILE(${filename} VMCWORKDIR ${CMAKE_SOURCE_DIR} APPEND)

  WRITE_TO_FILE(${filename} FAIRLIBDIR ${FAIRLIBDIR} APPEND)

  CONVERT_LIST_TO_STRING(${LD_LIBRARY_PATH})
  IF(CMAKE_SYSTEM_NAME MATCHES Linux)
    WRITE_TO_FILE(${filename} LD_LIBRARY_PATH ${output} APPEND)
  ELSE(CMAKE_SYSTEM_NAME MATCHES Linux)
    IF(CMAKE_SYSTEM_NAME MATCHES Darwin)
      WRITE_TO_FILE(${filename} DYLD_LIBRARY_PATH ${output} APPEND)
    ENDIF(CMAKE_SYSTEM_NAME MATCHES Darwin)
  ENDIF(CMAKE_SYSTEM_NAME MATCHES Linux)

  WRITE_TO_FILE(${filename} USE_VGM 1 APPEND)

#  STRING(REGEX MATCHALL "[^:]+" PATH1 ${PATH})
  SET (PATH ${ROOTSYS}/bin ${PATH})
  UNIQUE(PATH "${PATH}")
  CONVERT_LIST_TO_STRING(${PATH})
  WRITE_TO_FILE(${filename} PATH ${output} APPEND)

  WRITE_TO_FILE(${filename} PYTHIA8DATA "$SIMPATH/generators/pythia8/xmldoc" APPEND)

  IF (GEANT4_FOUND AND GEANT4VMC_FOUND AND CLHEP_FOUND)
    WRITE_FILE(${filename} ". ${GEANT4_DIR}/env.sh" APPEND)
  ENDIF (GEANT4_FOUND AND GEANT4VMC_FOUND AND CLHEP_FOUND)

  IF(RULE_CHECKER_FOUND)
    CONVERT_LIST_TO_STRING($ENV{NEW_CLASSPATH})
    WRITE_TO_FILE(${filename} CLASSPATH ${output} APPEND)
  ENDIF(RULE_CHECKER_FOUND)


  IF(CMAKE_SYSTEM_NAME MATCHES Linux)
    WRITE_FILE(${filename} "fi" APPEND)
  ENDIF(CMAKE_SYSTEM_NAME MATCHES Linux)

ENDMACRO (WRITE_CONFIG_FILE)


MACRO (WRITE_MINIMAL_CONFIG_FILE filename)

  IF(${filename} MATCHES "[.]csh")
    SET(CSH_OUT TRUE)
  ELSE(${filename} MATCHES "[.]csh")
    SET(CSH_OUT FALSE)
  ENDIF(${filename} MATCHES "[.]csh")

  SET(FAIRLIBDIR ${CMAKE_CURRENT_BINARY_DIR}/lib)
  
  IF(CMAKE_SYSTEM_NAME MATCHES Linux)
#    SET(LD_LIBRARY_PATH ${FAIRLIBDIR} ${LD_LIBRARY_PATH} /usr/lib /usr/X11R6/lib)
    SET(LD_LIBRARY_PATH ${FAIRLIBDIR} ${LD_LIBRARY_PATH})
  ELSE(CMAKE_SYSTEM_NAME MATCHES Linux)
    IF(CMAKE_SYSTEM_NAME MATCHES Darwin)
      SET(LD_LIBRARY_PATH ${FAIRLIBDIR} ${LD_LIBRARY_PATH})
    ENDIF(CMAKE_SYSTEM_NAME MATCHES Darwin)
  ENDIF(CMAKE_SYSTEM_NAME MATCHES Linux)
  
  WRITE_TO_FILE(${filename} ROOTSYS ${ROOTSYS} APPEND) 

  CONVERT_LIST_TO_STRING(${ROOT_LIBRARY_DIR})
  WRITE_TO_FILE(${filename} ROOT_LIBRARY_DIR ${output} APPEND)

  CONVERT_LIST_TO_STRING(${ROOT_LIBRARIES})
  WRITE_TO_FILE(${filename} ROOT_LIBRARIES ${output} APPEND)

  CONVERT_LIST_TO_STRING(${ROOT_INCLUDE_DIR})
  WRITE_TO_FILE(${filename} ROOT_INCLUDE_DIR ${output}  APPEND)

  WRITE_TO_FILE(${filename} VMCWORKDIR ${CMAKE_SOURCE_DIR} APPEND)

  WRITE_TO_FILE(${filename} FAIRLIBDIR ${FAIRLIBDIR} APPEND)

  CONVERT_LIST_TO_STRING(${LD_LIBRARY_PATH})
  IF(CMAKE_SYSTEM_NAME MATCHES Linux)
    WRITE_TO_FILE(${filename} LD_LIBRARY_PATH ${output} APPEND)
  ELSE(CMAKE_SYSTEM_NAME MATCHES Linux)
    IF(CMAKE_SYSTEM_NAME MATCHES Darwin)
      WRITE_TO_FILE(${filename} DYLD_LIBRARY_PATH ${output} APPEND)
    ENDIF(CMAKE_SYSTEM_NAME MATCHES Darwin)
  ENDIF(CMAKE_SYSTEM_NAME MATCHES Linux)

#  STRING(REGEX MATCHALL "[^:]+" PATH1 ${PATH})
  SET (PATH ${ROOTSYS}/bin $ENV{PATH})
  UNIQUE(PATH "${PATH}")
  CONVERT_LIST_TO_STRING(${PATH})
  WRITE_TO_FILE(${filename} PATH ${output} APPEND)


ENDMACRO (WRITE_MINIMAL_CONFIG_FILE)


MACRO (CONVERT_LIST_TO_STRING)

  set (tmp "")
  foreach (_current ${ARGN})

    set(tmp1 ${tmp})
    set(tmp "")
    set(tmp ${tmp1}:${_current})

  endforeach (_current ${ARGN})
  STRING(REGEX REPLACE "^:(.*)" "\\1" output ${tmp}) 

ENDMACRO (CONVERT_LIST_TO_STRING LIST)

MACRO (WRITE_TO_FILE FILENAME ENVVARIABLE VALUE OPTION)

  IF(CSH_OUT)
    WRITE_FILE(${FILENAME} "setenv ${ENVVARIABLE} \"${VALUE}\"" ${OPTION})
  ELSE(CSH_OUT)
    WRITE_FILE(${FILENAME} "export ${ENVVARIABLE}=\"${VALUE}\"" ${OPTION})
  ENDIF(CSH_OUT)

ENDMACRO (WRITE_TO_FILE)








