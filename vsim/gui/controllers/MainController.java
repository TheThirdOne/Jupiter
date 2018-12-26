package vsim.gui.controllers;

import vsim.Globals;
import vsim.utils.IO;
import javafx.fxml.FXML;
import javafx.stage.Stage;
import java.io.PrintStream;
import vsim.simulator.Status;
import javafx.scene.image.Image;
import javafx.scene.control.Tab;
import vsim.gui.utils.ConsoleInput;
import javafx.scene.input.Clipboard;
import javafx.scene.image.ImageView;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TextArea;
import javafx.beans.binding.Bindings;
import com.jfoenix.controls.JFXTabPane;
import javafx.scene.control.ContextMenu;
import vsim.gui.utils.CustomOutputStream;
import javafx.scene.input.ClipboardContent;

/**
 * Main controller class.
 */
public class MainController {

  /** Main tab pane */
  @FXML protected JFXTabPane main;
  /** Main tab pane editor tab */
  @FXML protected Tab editorTab;
  /** Main tab pane simulator tab */
  @FXML protected Tab simTab;

  /** Console text area */
  @FXML protected TextArea console;

  /** Reference to editor controller */
  @FXML protected EditorController editorController;
  /** Reference to menubar controller */
  @FXML protected MenuBarController menuBarController;
  /** Reference to simulator controller */
  @FXML protected SimulatorController simulatorController;

  /** Primary stage */
  protected Stage stage;

  /**
   * Initialize main controller class and other controllers.
   *
   * @param stage primary stage
   */
  public void initialize(Stage stage) {
    this.stage = stage;
    this.initConsole();
    // disable simulation tab if project is not ready
    this.simTab.disableProperty().bind(Bindings.not(Status.READY));
    // set ready to false whenever the tab being selected is the editor tab
    this.main.getSelectionModel().selectedItemProperty().addListener((e, oldTab, newTab) -> {
      if (newTab == this.editorTab)
        Status.READY.set(false);
    });
    this.editorController.initialize(this);
    this.menuBarController.initialize(this);
    this.simulatorController.initialize(this);
  }

  /**
   * Selects editor tab.
   */
  protected void selectEditorTab() {
    this.main.getSelectionModel().select(this.editorTab);
  }

  /**
   * Selects simulator tab.
   */
  protected void selectSimulatorTab() {
    this.main.getSelectionModel().select(this.simTab);
  }

  /**
   * Initialize V-Sim console text area.
   */
  private void initConsole() {
    // assign the new gui "standard input"
    IO.guistdin = new ConsoleInput(this.console);
    // redirect stdout and stderr
    IO.stdout = new PrintStream(new CustomOutputStream(this.console));
    IO.stderr = IO.stdout;
    // clear option
    MenuItem clear = new MenuItem("clear");
    clear.setOnAction(e -> this.console.setText(""));
    ImageView clearImg = new ImageView();
    clearImg.setFitWidth(20.0);
    clearImg.setFitHeight(20.0);
    clearImg.setImage(new Image(getClass().getResourceAsStream("/resources/img/icons/clear.png")));
    clear.setGraphic(clearImg);
    // copy option
    MenuItem copy = new MenuItem("copy");
    copy.setOnAction(e -> {
      Clipboard clipboard = Clipboard.getSystemClipboard();
      ClipboardContent content = new ClipboardContent();
      content.putString(this.console.getSelectedText());
      clipboard.setContent(content);
    });
    ImageView copyImg = new ImageView();
    copyImg.setFitWidth(20.0);
    copyImg.setFitHeight(20.0);
    copyImg.setImage(new Image(getClass().getResourceAsStream("/resources/img/icons/copy.png")));
    copy.setGraphic(copyImg);
    // copy all option
    MenuItem copyAll = new MenuItem("copy all");
    copyAll.setOnAction(e -> {
      Clipboard clipboard = Clipboard.getSystemClipboard();
      ClipboardContent content = new ClipboardContent();
      content.putString(this.console.getText());
      clipboard.setContent(content);
    });
    ImageView copyAllImg = new ImageView();
    copyAllImg.setFitWidth(20.0);
    copyAllImg.setFitHeight(20.0);
    copyAllImg.setImage(new Image(getClass().getResourceAsStream("/resources/img/icons/copyAll.png")));
    copyAll.setGraphic(copyAllImg);
    // set context menu with this options
    ContextMenu menu = new ContextMenu();
    menu.getItems().addAll(clear, copy, copyAll);
    this.console.setContextMenu(menu);
  }

}
