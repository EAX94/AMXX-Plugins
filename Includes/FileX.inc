#if defined _FileX_included
  #endinput
#endif
#define _FileX_included

#if !defined _file_included
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif



/* Attempts to remove a directory.
* Returns 1 on success, 0 on failure.
* Note that you cannot remove a directory that has files on most operating systems.
*/
native DeleteDirX(const path[]);

/* Deletes file. Returns 1 on success, 0 on failure. */
native DeleteFileX(const file[]);

/* Checks if a file exists. Returns 1 if it exists, 0 if it doesn't. */
native FileExistsX(const file[]);

/* Returns a file size in bytes if flag is set to 0.
* When flag is set to 1 returns number of lines in the file,
* and when flags is 2, function returns 1 if the file ends
* with line feed. If file doesn't exist returns -1. */
native FilesizeX(const file[], flag=0);

//Open a file, returns a handle or 0 on failure
native fOpenX(const filename[], const mode[]);

/* Returns 0 on success, -1 on failure. */
native MakeDirX(const dirname[]);

/* Returns a handle to a directory. */
native OpenDirX(const dir[], firstfile[], len);

/* Renames a file. Returns 0 on failure, 1 on success. */
native RenameX(const oldname[], const newname[]);

/* Checks if a directory exists */
stock DirExistsX(const dir[]) { return ( FileExistsX(dir) && FilesizeX(dir) == -1 ) ; }

/* These are just to fit the original natives with mine. */
#define fCloseX(%0) fclose(%0)
#define fReadX(%0,%1,%2) fread(%0, %1, %2)
#define fReadBlocksX(%0,%1,%2,%3) fread_blocks(%0, %1, %2, %3)
#define fReadRawX(%0,%1,%2,%3) fread_raw(%0, %1, %2, %3)
#define fWriteX(%0,%1,%2) fwrite(%0, %1, %2)
#define fWriteBlocksX(%0,%1,%2,%3) fwrite_blocks(%0, %1, %2, %3)
#define fWriteRawX(%0,%1,%2,%3) fwrite_raw(%0, %1, %2, %3)
#define fEofX(%0) feof(%0)
#define fGetSX(%0,%1,%2) fgets(%0, %1, %2)
#define fPutSX(%0,%1,%2) fputs(%0, %1, %2)
#define fPrintFX(%0,%1,%2) fprintf(%0, %1, %2)
#define fSeekX(%0,%1,%2) fseek(%0, %1, %2)
#define fTellX(%0) ftell(%0)
#define fGetCX(%0) fgetc(%0)
#define fPutCX(%0,%1) fputc(%0, %1)
#define fUngetCX(%0,%1) fungetc(%0, %1)
#define NextFileX(%0,%1,%2) next_file(%0, %1, %2)
#define CloseDirX(%0) close_dir(%0)

/* And these are to fit my natives with the original */
#define rmdirx(%0) DeleteDirX(%0)
#define delete_dirx(%0) DeleteDirX(%0)
#define remove_dirx(%0) DeleteDirX(%0)
#define delete_filex(%0) DeleteFileX(%0)
#define remove_filex(%0) DeleteFileX(%0)
#define file_existsx(%0) FileExistsX(%0)
#define filesizex(%0,%1) FilesizeX(%0,%1)
#define fopenx(%0,%1) fOpenX(%0,%1)
#define mkdirx(%0) MakeDirX(%0)
#define makedirx(%0) MakeDirX(%0)
#define make_dirx(%0) MakeDirX(%0)
#define createdirx(%0) MakeDirX(%0)
#define create_dirx(%0) MakeDirX(%0)
#define open_dirx(%0,%1,%2) OpenDirX(%0,%1,%2)
#define rename_filex(%0,%1) RenameX(%0,%1)
#define rename_dirx(%0,%1) RenameX(%0,%1)
#define dir_existsx(%0) DirExistsX(%0)
