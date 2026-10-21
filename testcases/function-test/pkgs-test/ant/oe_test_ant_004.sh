#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

####################################
#@Author    	:   songliying
#@Contact   	:   liying@isrc.iscas.ac.cn
#@Date      	:   2022-09-27
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   Test ant
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ant
    mkdir -p testdir
    mkdir -p $HOME/.ant/lib
    echo "rpm_mode=false" > $HOME/.ant/ant.conf
    cp /usr/share/ant/lib/ant-launcher.jar $HOME/.ant/lib/test_nouserlib.jar
    cat > testdir/build.xml <<EOF
<?xml version="1.0"?>
<project name="Test" default="test" basedir="">
    <target name="test">
        <echo message="yourclasspath:\${java.class.path}" />
    </target>
</project>
EOF
    cp testdir/build.xml build.xml
    cat > build_for_D.xml <<EOF
<?xml version="1.0"?>
<project name="Test" default="test" basedir="">
    <target name="test">
        <echo message="value of property aaa is \${aaa}" />
    </target>
</project>
EOF
    cat > build_for_k.xml <<EOF
<?xml version="1.0"?>
<project name="Test" default="test1" basedir="">
    <target name="test1">
        <input message="input a num:"/>
    </target>
    <target name="test2">
        <echo message="run test2" />
    </target>
    <target name="test3">
        <echo message="run test3" />
    </target>
    <target name="test4">
        <echo message="run test4" />
    </target>
    <target name="test5">
        <echo message="run test5" />
    </target>
</project>
EOF
    cat > antpropertyfile <<EOF
os=openeuler
testby=mugen
EOF
    cat > build_for_propertyfile.xml <<EOF
<?xml version="1.0"?>
<project name="Test" default="test1" basedir="">
    <target name="test1">
        <echo message="os=\${os}" />
        <echo message="testby=\${testby}" />
    </target>
</project>
EOF
    cat > build_for_inputhandler.xml <<EOF
<?xml version="1.0"?>
<project name="Test" default="test" basedir="">
    <target name="test">
        <input message="input: " />
        <echo message="yourclasspath:\${java.class.path}" />
    </target>
</project>
EOF
    cat > PrintProperties.java <<EOF
import java.util.Properties;
import java.util.Set;
public class PrintProperties {
    public static void main(String[] args) {
        Properties p = System.getProperties();
        Set<String> set = p.stringPropertyNames();
        for (String name : set) {
            System.out.println(name + "=" + p.getProperty(name));
        }
    }
}
EOF
    cat > build_for_print_prop.xml <<EOF
<?xml version="1.0"?>
<project name="PrintProp" default="test1" basedir="">
    <target name="test1">
        <javac srcdir="." />
        <java classname="PrintProperties">
            <classpath path="."/>
        </java>
    </target>
</project>
EOF
    cat > CustomExitCode.java <<EOF
public class CustomExitCode extends org.apache.tools.ant.Main {
    protected void exit(int exitCode) {
        System.out.println("all finished...");
    }
}
EOF
    cat > MyHandler.java <<EOF
import org.apache.tools.ant.input.InputRequest;
import org.apache.tools.ant.input.GreedyInputHandler;
import org.apache.tools.ant.BuildException;
public class MyHandler extends GreedyInputHandler {
    @Override
    public void handleInput(InputRequest request) throws BuildException {
        System.out.println("my input handler");
        super.handleInput(request);
    }
}
EOF
    javac -cp "/usr/share/ant/lib/*" CustomExitCode.java
    javac -cp "/usr/share/ant/lib/*" MyHandler.java
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ant -Daaa=123 -f build_for_D.xml | grep -F "value of property aaa is 123"
    CHECK_RESULT $? 0 0 "test failed with option -D"
    ant -k -noinput -f build_for_k.xml test1 test2 test3 test4 test5 | grep "run test[2-5]"
    CHECK_RESULT $? 0 0 "test failed with option -k"
    ant -keep-going -noinput -f build_for_k.xml test1 test2 test3 test4 test5 | grep "run test[2-5]"
    CHECK_RESULT $? 0 0 "test failed with option -keep-going"
    ant -propertyfile antpropertyfile -f build_for_propertyfile.xml | grep -Pz "\[echo\] os=openeuler\s+\[echo\] testby=mugen"
    CHECK_RESULT $? 0 0 "test failed with option -propertyfile"
    echo "hello" | CLASSPATH=. ant -f build_for_inputhandler.xml -inputhandler MyHandler | grep "my input handler"
    CHECK_RESULT $? 0 0 "test failed with option -inputhandler"
    ant -find testdir | grep -Pz "Buildfile:[\S\s]*test[\S\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -find"
    ant -s testdir | grep -Pz "Buildfile:[\S\s]*test[\S\s]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -s"
    echo -e "1" | ant -nice 2 -f build_for_k.xml test1 test2 test3 test4 test5 | grep -Pz "test[1-5]:[\s\S]*BUILD SUCCESSFUL"
    CHECK_RESULT $? 0 0 "test failed with option -nice"
    ant -nouserlib -f testdir | grep -F "$HOME/.ant/lib/test_nouserlib.jar"
    CHECK_RESULT $? 1 0 "test failed with option -nouserlib"
    CLASSPATH=aaa ant -noclasspath | grep "aaa"
    CHECK_RESULT $? 1 0 "test failed with option -noclasspath"
    ant -autoproxy -f build_for_print_prop.xml -lib $PWD | grep -F "java.net.useSystemProxies=true"
    CHECK_RESULT $? 0 0 "test failed with option -autoproxy"
    ant -main CustomExitCode -lib . | grep "yourclasspath"
    CHECK_RESULT $? 0 0 "test failed with option -main"
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf testdir *.xml *.java *.class $HOME/.ant antpropertyfile
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
