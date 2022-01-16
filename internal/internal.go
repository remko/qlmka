package main

import (
	"log"
	"unsafe"

	"github.com/remko/go-mkvparse"
)

import "C"

//export GetMKAThumb
func GetMKAThumb(cpath *C.char, maxWidth C.float, maxHeight C.float) (code C.int, outData unsafe.Pointer, outLen C.long) {
	path := C.GoString(cpath)
	data, _, err := mkvparse.ParseCover(path)
	if err != nil {
		log.Printf("error reading thumb: %v", err)
		return -1, nil, 0
	}
	if data == nil {
		return 0, nil, 0
	}
	return 0, C.CBytes(data), C.long(len(data))
}

func main() {}
