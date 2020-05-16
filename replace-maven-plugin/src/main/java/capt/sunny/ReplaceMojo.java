package capt.sunny;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.logging.Log;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;

@Mojo(name = "run")
public class ReplaceMojo extends AbstractMojo {
    @Parameter(property = "path")
    private String pathToReplace;

    @Parameter(property = "source-word")
    private String sourceWord;

    @Parameter(property = "result-word")
    private String resultWord;

    public void execute() {
        Log logger = getLog();

        try {
            logger.info(String.format("Try to replace `%s` with `%s` in path `%s`", sourceWord, resultWord, pathToReplace));

            Path path = Paths.get(pathToReplace);

            if (!path.toFile().exists()) {
                logger.warn(String.format("`%s` does not exist", pathToReplace));
                return;
            }

            if (!path.toFile().canExecute() && !path.toFile().isFile()) {
                logger.warn(String.format("Can not execute `%s`", pathToReplace));
                return;
            }

            if (path.toFile().isFile()) {
                replaceFileWords(path);
                return;
            }

            replaceWordsInDirFiles(path);
        } catch (IOException e) {
            getLog().error(e);
        }
    }

    private void replaceWordsInDirFiles(Path path) {
        for (File file : path.toFile().listFiles()) {
            if (file.isFile()) {
                try {
                    replaceFileWords(Paths.get(file.getPath()));
                } catch (IOException e) {
                    getLog().error(e);
                }
            } else if (file.isDirectory())
                replaceWordsInDirFiles(Paths.get(file.getPath()));
        }
    }

    private void replaceFileWords(Path path) throws IOException {
        getLog().info(String.format("Replacing words in `%s`", path.toString()));

        if (!path.toFile().canRead() || !path.toFile().canWrite()) {
            getLog().warn(String.format("Insufficient permissions on the `%s` file", path.toFile().getPath()));
            return;
        }

        String oldData = String.join(
                System.lineSeparator(),
                Files.readAllLines(path, StandardCharsets.UTF_8)
        );
        String newData = oldData.replace(sourceWord, resultWord);

        if (newData.isEmpty())
            return;

        Files.write(path, Collections.singleton(newData), StandardCharsets.UTF_8);
    }
}
