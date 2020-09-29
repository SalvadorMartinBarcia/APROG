{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_factoriales (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Borja\\Desktop\\APROG\\practicas\\Practica 1\\practica 1a\\factoriales\\.stack-work\\install\\5d511462\\bin"
libdir     = "C:\\Users\\Borja\\Desktop\\APROG\\practicas\\Practica 1\\practica 1a\\factoriales\\.stack-work\\install\\5d511462\\lib\\i386-windows-ghc-8.0.2\\factoriales-0.1.0.0-EuJ635aIkR9E8nGAsThFH1"
dynlibdir  = "C:\\Users\\Borja\\Desktop\\APROG\\practicas\\Practica 1\\practica 1a\\factoriales\\.stack-work\\install\\5d511462\\lib\\i386-windows-ghc-8.0.2"
datadir    = "C:\\Users\\Borja\\Desktop\\APROG\\practicas\\Practica 1\\practica 1a\\factoriales\\.stack-work\\install\\5d511462\\share\\i386-windows-ghc-8.0.2\\factoriales-0.1.0.0"
libexecdir = "C:\\Users\\Borja\\Desktop\\APROG\\practicas\\Practica 1\\practica 1a\\factoriales\\.stack-work\\install\\5d511462\\libexec"
sysconfdir = "C:\\Users\\Borja\\Desktop\\APROG\\practicas\\Practica 1\\practica 1a\\factoriales\\.stack-work\\install\\5d511462\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "factoriales_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "factoriales_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "factoriales_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "factoriales_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "factoriales_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "factoriales_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
