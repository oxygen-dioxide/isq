all: teleport.so

teleport.so: teleport.c teleport.ll ../../src/facades/qir/shim/qir_builtin/shim.ll ../../src/facades/qir/shim/qsharp_core/shim.ll ../../src/facades/qir/shim/qsharp_foundation/shim.ll
	clang -shared -fPIC -o teleport.so teleport.c teleport.ll ../../src/facades/qir/shim/qir_builtin/shim.ll ../../src/facades/qir/shim/qsharp_core/shim.ll ../../src/facades/qir/shim/qsharp_foundation/shim.ll

clean:
	rm teleport.so