#include <stdio.h>
#include <ffi.h>
int main()
{
  ffi_cif cif;
  ffi_type *args[1];
  void *values[1];
  char *s;
  ffi_arg rc;

  args[0] = &ffi_type_pointer;
  values[0] = &s;

  if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 1,
                       &ffi_type_sint, args) == FFI_OK)
    {
      s = "Hello World!";
      ffi_call(&cif, puts, &rc, values);
      s = "This is cool!";
      ffi_call(&cif, puts, &rc, values);
    }
  return 0;
}

