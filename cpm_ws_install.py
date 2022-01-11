import shutil
import errno
import sys
import os
#
def copy_header(src, dst, *, follow_symlinks=True):
    exten = os.path.splitext(src)[1].casefold()
    #
    if os.path.isdir(dst):
        dst = os.path.join(dst, os.path.basename(src))
    #
    if exten == ".h" or exten == ".hpp" or exten == ".hxx" or exten == ".inl":
        shutil.copyfile(src, dst, follow_symlinks=follow_symlinks)
    #
    return dst
#   
targetFile = None
installPrefix = None
buildConfig = None
componentName = None
binaryPath = None
includePaths = None
defines = None
link_libraries = None
#
argIdx = 0
#
while argIdx < len(sys.argv):
    if sys.argv[argIdx].casefold() == "-target_file":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                targetFile = sys.argv[valIdx]
                argIdx = valIdx
    #
    elif sys.argv[argIdx].casefold() == "-install_prefix":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                installPrefix = sys.argv[valIdx]
                argIdx = valIdx
    #
    elif sys.argv[argIdx].casefold() == "-binary":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                binaryPath = sys.argv[valIdx]
                argIdx = valIdx
    #
    elif sys.argv[argIdx].casefold() == "-includes":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                includePaths = sys.argv[valIdx].split(',')
                argIdx = valIdx
    #
    elif sys.argv[argIdx].casefold() == "-defines":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                defines = sys.argv[valIdx].split(',')
                argIdx = valIdx
    elif sys.argv[argIdx].casefold() == "-link_libraries":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                link_libraries = sys.argv[valIdx].split(',')
                argIdx = valIdx
    #
    elif sys.argv[argIdx].casefold() == "-config":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                buildConfig = sys.argv[valIdx]
                argIdx = valIdx
    #
    elif sys.argv[argIdx].casefold() == "-type":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                buildType = sys.argv[valIdx]
                argIdx = valIdx
    #
    elif sys.argv[argIdx].casefold() == "-name":
        for valIdx in range(argIdx + 1, len(sys.argv)):
            if sys.argv[valIdx].startswith("-"):
                break;
            else:
                componentName = sys.argv[valIdx]
                argIdx = valIdx
    #
    argIdx+=1
#
if len(buildType) > 0:
    #includeInstallDir = "{0}/include".format(installPrefix)
    libDir = "{0}/lib/".format(installPrefix)
    #
    #if includePaths is not None:
    #    #if os.path.exists(includeInstallDir):
    #    #    try:
    #    #        shutil.rmtree(includeInstallDir, ignore_errors=True)
    #    #    except OSError as exc:
    #    #        print("ERROR: shutil.rmtree({0}), {1}".format(includeInstallDir, exc))
    #    ##
    #    for i in includePaths:
    #        try:
    #            shutil.copytree(i, includeInstallDir, dirs_exist_ok=True, copy_function=copy_header)
    #        except OSError as exc:
    #            print("ERROR: shutil.copytree({0}, {1}), {2}".format(i, includeInstallDir, exc))
    #
    if buildType.casefold() == "staticlib":
        targetFileName = os.path.basename(targetFile)
        #installedTargetFile = "{0}{1}".format(libDir, targetFileName)
        #
        #try:
        #    shutil.copy(targetFile, installedTargetFile)
        #except OSError as exc:
        #    print("ERROR: shutil.copy({0}, {1}), {2}".format(targetFile, installedTargetFile, exc))
        #
        with open("{0}/cpm_ws_{1}.cmake".format(installPrefix, componentName), "w+") as package_script:
            print("add_library({0} STATIC IMPORTED)".format(componentName), file=package_script)
            if defines is not None:
                print("target_compile_definitions({0} INTERFACE".format(componentName), file=package_script)
                for d in defines:
                    print("     {0} ".format(d), file=package_script)
                print(" )", file=package_script)
            #
            if includePaths is not None:
                print("target_include_directories({0} INTERFACE".format(componentName), file=package_script)
                #print(" ", includeInstallDir, file=package_script)
                for i in includePaths:
                        print(" {0}".format(i), file=package_script)
                print(" )", file=package_script)
            #
            if link_libraries is not None:
                print("target_link_libraries({0} INTERFACE".format(componentName), file=package_script)
                for l in link_libraries:
                    print("     {0} ".format(d), file=package_script)
                print(" )", file=package_script)
            #
            print("set_property(TARGET {0} APPEND PROPERTY IMPORTED_CONFIGURATIONS {1})".format(componentName, buildConfig.upper()), file=package_script)
            print("set_target_properties({0} PROPERTIES".format(componentName), file=package_script)
            print(" IMPORTED_LINK_INTERFACE_LANGUAGES_{0} \"CXX\"".format(buildConfig.upper()), file=package_script)
            print(" IMPORTED_LOCATION_{0} \"{1}\")".format(buildConfig.upper(), targetFile), file=package_script)
            #print(" IMPORTED_LOCATION_{0} \"{1}\")".format(buildConfig.upper(), installedTargetFile), file=package_script)
            package_script.close()
    #
    elif buildType.casefold() == "headerlib":
        with open("{0}/cpm_ws_{1}.cmake".format(installPrefix, componentName), "w+") as package_script:
            print("add_library({0} INTERFACE)".format(componentName), file=package_script)
            if defines is not None:
                print("target_compile_definitions({0} INTERFACE".format(componentName), file=package_script)
                for d in defines:
                    print("     {0} ".format(d), file=package_script)
                print(" )", file=package_script)
            #
            if includePaths is not None:
                print("target_include_directories({0} INTERFACE".format(componentName), file=package_script)
                #print(" ", includeInstallDir, file=package_script)
                for i in includePaths:
                        print(" {0}".format(i), file=package_script)
                print(" )", file=package_script)
            #
            if link_libraries is not None:
                print("target_link_libraries({0} INTERFACE".format(componentName), file=package_script)
                for l in link_libraries:
                    print("     {0} ".format(d), file=package_script)
                print(" )", file=package_script)
            #
            package_script.close()
    #
    elif buildType.casefold() == "dynamiclib":
        print("targetFile:      ", targetFile)    
        if binaryPath is not None:
            print(binaryPath)
        #
        if includePaths is not None:
            print("includePaths:    ", includePaths)
        #
        if defines is not None:
            print("defines:         ", defines)
    #
    elif buildType.casefold() == "pipelinetool":
        print("targetFile:      ", targetFile)    
        if binaryPath is not None:
            print("binaryPath:      ", binaryPath)
    #
#
