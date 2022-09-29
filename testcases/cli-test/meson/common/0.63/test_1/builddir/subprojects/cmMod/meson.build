project('cmMod', 'cpp')
cmModLib___dir = include_directories('__CMake_build', '.')
cmModLib___sys = include_directories(is_system : true)
cmModLib___inc = [cmModLib___dir, cmModLib___sys]
cmModLib___src = files('cmMod.cpp')
cmModLib__ = shared_library(
  'cmModLib__',
  cmModLib___src,
  build_by_default : false,
  link_args : [],
  link_with : [],
  include_directories : cmModLib___inc,
  install : false,
  override_options : [],
  objects : [],
  cpp_args : ['-DDO_NOTHING_JUST_A_FLAG=1', '-DMESON_MAGIC_FLAG=21', '-DcmModLib___EXPORTS']
)
cmModLib___dep = declare_dependency(
  link_args : [],
  link_with : cmModLib__,
  compile_args : ['-DMESON_MAGIC_FLAG=42'],
  include_directories : cmModLib___inc
)
