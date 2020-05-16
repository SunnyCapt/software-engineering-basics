## Maven plugin for global replace

### Installation

    git clone https://github.com/SunnyCapt/software-engineering-basics.git
    cd  software-engineering-basics/replace-maven-plugin
    mvn install
    
### Usage

  - add into  project.build.plugins of your project pom.xml:
   
   
     <plugin>
         <groupId>capt.sunny</groupId>
         <artifactId>replace-plugin</artifactId>
         <version>2.0</version>
         <configuration>
             <pathToReplace>
                 src\main\resources
             </pathToReplace>
             <sourceWord>sleep</sourceWord>
             <resultWord>write maven plugin</resultWord>
         </configuration>
     </plugin>
     
     
  - run `mvn replace:run`