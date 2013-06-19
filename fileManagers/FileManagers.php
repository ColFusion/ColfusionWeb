<?php

require_once('FileUploadPageModel.php');
require_once('FileListItemModel.php');
include_once('../DAL/QueryEngine.php');

include_once('../config.php');

abstract class FileManager {

    // Create a FileUploadPageModel instance for use of upload page.
    // The model contains upload url, delete url, and other info needed by upload page.
    abstract public function createFileUploadPageModel();
    
    // This funciton should save file to file system and handle DB update.
    // Return a FileListItemModel.
    // $_FILE is php's $_FILES['name'].
    abstract public function saveFile($sourceId, $userId, $_FILE, $description);

    // This funciton should delete file on file system and handle DB update.
    // Use userId to check if the file is deleted by uploader.
    abstract public function deleteFile($fileId, $userId);

    // Returns the real path of a file.
    abstract public function downloadFile($fileId);
    
    // Get icon based on extension.
    public function getIconUrl($filename){
        $path_parts = pathinfo($filename);
        $ext = $path_parts['extension'];
              
        $icon_dir = 'icons/';
        switch($ext){
            case 'doc':          
            case 'docx':              
            case 'xls':            
            case 'xlsx':             
            case 'xlsx':              
            case 'xlsx':         
            case 'ppt':              
            case 'pptx':              
            case 'pdf':             
            case 'sql':
                $icon_filename = $ext.'.jpg';
                break;
            case 'jpg':
            case 'jpeg':
            case 'png':
            case 'tiff':
            case 'gif':
                $icon_filename = 'image.png';
                break;
            default:
                $icon_filename = 'file.jpg';
                break;
        }
        
       
        return $icon_dir.$icon_filename;
    }
}

class SourceDesAttachmentManager extends FileManager {

    // Directory which stores attachments.
    private static $attachment_dir;
    private static $instance;

    public static function getInstance() {
        if (!self::$instance)
            self::$instance = new SourceDesAttachmentManager();
        return self::$instance;
    }

    private function __construct() {
        self::$attachment_dir = mnmpath."sourceDesAttachments/";
    }

    // See IFileManager.
    public function createFileUploadPageModel() {
        $model = new FileUploadPageModel();
        $model->uploadController = "/fileManagers/uploadSourceAttachments.php";
        $model->deleteController = "/fileManagers/deleteSourceAttachment.php";
        $model->wellText = '<h3>Notes</h3>
            <ul>
                <li>The maximum file size is <strong>20 MB</strong>.</li>       
                <li>You can <strong>drag &amp; drop</strong> files from your desktop on this webpage with Google Chrome, Mozilla Firefox and Apple Safari.</li>
            </ul>';
        return $model;
    }

    // See IFileManager.
    public function saveFile($sourceId, $userId, $_FILE, $description) {

        // jQuery file upload put file info in array.
        if (is_array($_FILE['name']))       $_FILE['name'] = $_FILE['name'][0];
        if (is_array($_FILE['tmp_name']))   $_FILE['tmp_name'] = $_FILE['tmp_name'][0];
        if (is_array($_FILE['size']))       $_FILE['size'] = $_FILE['size'][0];

        $title = $filename = $_FILE['name'];
        $basename = substr($filename, 0, strripos($filename, '.'));

        // If file exists, change filename.
        if (!file_exists(self::$attachment_dir))
            mkdir(self::$attachment_dir);

        $path_parts = pathinfo($filename);
        for ($i = 1; file_exists(self::$attachment_dir . $filename); $i++) {
            $filename = $basename . "_" . $i . "." . $path_parts['extension'];
        }

        // Store file at FS.
        move_uploaded_file($_FILE['tmp_name'], self::$attachment_dir . $filename);

        // Store file info into database.
        $queryEngine = new QueryEngine();
        $fileId = $queryEngine->simpleQuery->addSourceAttachmentInfo($sourceId, $userId, $title, $filename, $_FILE['size'], $description);

        // Build model for file list in upload page.
        $listItemModel = new FileListItemModel();
        $listItemModel->name = $title;
        $listItemModel->size = $_FILE['size'];
        $listItemModel->thumbnail_url = $this->getIconUrl($filename);
        $listItemModel->delete_url = "deleteSourceAttachment.php?fileId=" . $fileId;
        $listItemModel->url = "downloadSourceAttachment.php?fileId=" . $fileId;
        $listItemModel->description = $description;
        return $listItemModel;
    }

    // See IFileManager.
    public function deleteFile($fileId, $userId) {
        // Delete file info.
        $queryEngine = new QueryEngine();
        $filename = $queryEngine->simpleQuery->deleteSourceAttachmentInfo($fileId, $userId);
        
        // Delete file from FS.
        unlink(self::$attachment_dir . $filename);
    }

    // See IFileManager.
    public function downloadFile($fileId) {
        $queryEngine = new QueryEngine();
        $fileInfo = $queryEngine->simpleQuery->getSourceAttachmentInfo($fileId);
        if($fileInfo == null) return null;
        
        $fileInfo->path = self::$attachment_dir . $fileInfo->Filename;
        return $fileInfo;
    }
    
    // Get info of all attachments of a source.
    // Return an array of DB-mapping objects.
    public function getSourceAttachmentsInfo($sid){
        $queryEngine = new QueryEngine();
        $results = $queryEngine->simpleQuery->getSourceAttachmentsInfo($sid);
        
        if (isset($results)) {
        	foreach($results as $result){
                    $result->icon_url = $this->getIconUrl($result->Filename);
        	}
        }
        return $results;
    }
}

?>