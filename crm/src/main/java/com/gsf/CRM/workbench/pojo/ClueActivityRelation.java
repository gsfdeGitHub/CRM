package com.gsf.CRM.workbench.pojo;

public class ClueActivityRelation {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.id
     *
     * @mbg.generated
     */
    private String id;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.clue_id
     *
     * @mbg.generated
     */
    private String clueId;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_clue_activity_relation.activity_id
     *
     * @mbg.generated
     */
    private String activityId;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.id
     *
     * @return the value of tbl_clue_activity_relation.id
     *
     * @mbg.generated
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.id
     *
     * @param id the value for tbl_clue_activity_relation.id
     *
     * @mbg.generated
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.clue_id
     *
     * @return the value of tbl_clue_activity_relation.clue_id
     *
     * @mbg.generated
     */
    public String getClueId() {
        return clueId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.clue_id
     *
     * @param clueId the value for tbl_clue_activity_relation.clue_id
     *
     * @mbg.generated
     */
    public void setClueId(String clueId) {
        this.clueId = clueId == null ? null : clueId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_clue_activity_relation.activity_id
     *
     * @return the value of tbl_clue_activity_relation.activity_id
     *
     * @mbg.generated
     */
    public String getActivityId() {
        return activityId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_clue_activity_relation.activity_id
     *
     * @param activityId the value for tbl_clue_activity_relation.activity_id
     *
     * @mbg.generated
     */
    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }
}