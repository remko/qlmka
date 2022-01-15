package main

import (
	"log"
	"unsafe"

	"github.com/remko/go-mkvparse"
)

/*
#include <memory.h>
*/
import "C"

//export GetMKAThumb
func GetMKAThumb(rawPath *C.char, maxWidth C.float, maxHeight C.float, outData unsafe.Pointer, outLen unsafe.Pointer) C.int {
	path := C.GoString(rawPath)
	data, _, err := mkvparse.ParseCover(path)
	if err != nil {
		log.Printf("error reading thumb: %v", err)
		*(*C.int)(outLen) = 0
		*(**C.char)(outData) = nil
		return -1
	}
	if data == nil {
		*(*C.int)(outLen) = 0
		*(**C.char)(outData) = nil
		return 0
	}
	*(*C.int)(outLen) = (C.int)(len(data))
	*(**C.char)(outData) = (*C.char)(C.malloc(C.ulong(len(data))))
	C.memcpy(unsafe.Pointer(*(**C.char)(outData)), unsafe.Pointer(&data[0]), C.ulong(len(data)))
	return 0
}

func main() {}
