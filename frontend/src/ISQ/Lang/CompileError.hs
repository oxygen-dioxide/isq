{-# LANGUAGE DeriveGeneric #-}
module ISQ.Lang.CompileError where
import ISQ.Lang.ISQv2Grammar
import ISQ.Lang.TypeCheck (TypeCheckError)
import ISQ.Lang.RAIICheck (RAIIError)
import ISQ.Lang.DeriveGate (DeriveError)
import ISQ.Lang.OraclePass (OracleError)
--import ISQ.Lang.FlatInc (IncFileError)

data CompileError = 
    GrammarError GrammarError
  | DeriveError DeriveError
  | OracleError OracleError
  | TypeCheckError TypeCheckError 
  | RAIIError RAIIError
  | InternalCompilerError InternalCompilerError
--  | IncFileError IncFileError 
  | SyntaxError Pos deriving (Eq, Show)

class CompileErr e where
  fromError :: e->CompileError
instance CompileErr CompileError where
  fromError x = x
instance CompileErr GrammarError where
  fromError = GrammarError 
instance CompileErr TypeCheckError where
  fromError = TypeCheckError 
instance CompileErr RAIIError where
  fromError = RAIIError 
instance CompileErr InternalCompilerError where
  fromError = ISQ.Lang.CompileError.InternalCompilerError 
instance CompileErr DeriveError where
  fromError = DeriveError
instance CompileErr OracleError where
  fromError = OracleError
--instance CompileErr IncFileError where
--  fromError = IncFileError