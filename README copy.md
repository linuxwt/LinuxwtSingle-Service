## 1、tomcat_web里是以centos7为基础镜像部署的tomcat的Web服务实例  

### 1.1、构建镜像前前，请执行命令bash jdk.sh  

### 1.2、文件映射说明  

#### 1.2.1、setclasspath.sh通过加入JAVA_HOME和JAVA_JRE路径后解决了报错：  

```bash
Neither the JAVA_HOME nor the JRE_HOME environment variable is defined At least one of these environment variable is needed to run this program
```  

#### 1.2.2、project_code下的文件来自于tomcat解压文件的webapps/ROOT，如果没有这些文件将无法访问tomcat默认页面
