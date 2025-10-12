package model;

public class PageControl {
    private int totalPages;
    private int totalRecord;
    private int page;
    private String urlPattern;

    public PageControl() {
    }

    
    public PageControl(int totalPages, int totalRecord, int page, String urlPattern) {
        this.totalPages = totalPages;
        this.totalRecord = totalRecord;
        this.page = page;
        this.urlPattern = urlPattern;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public int getTotalRecord() {
        return totalRecord;
    }

    public void setTotalRecord(int totalRecord) {
        this.totalRecord = totalRecord;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public String getUrlPattern() {
        return urlPattern;
    }

    public void setUrlPattern(String urlPattern) {
        this.urlPattern = urlPattern;
    }
    
    
    
    
}