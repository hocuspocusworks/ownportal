<template>
    <!-- @click="changeMe($event.currentTarget)" -->
    <div class="accordion" id="accordionExample">
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingOne">
                <button
                    class="accordion-button"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#collapseOne"
                    aria-expanded="true"
                    aria-controls="collapseOne"
                >Accordion Item #1</button>
            </h2>
            <div
                id="collapseOne"
                class="accordion-collapse collapse show"
                aria-labelledby="headingOne"
                data-bs-parent="#accordionExample"
            >
                <div class="accordion-body">
                    <strong>Sources</strong>
                    <p>Feed 1</p>
                    <div>
                        <button type="button" class="btn btn-secondary me-2">Open Feed</button>
                        <button
                            type="button"
                            class="btn btn-secondary"
                            data-bs-toggle="modal"
                            data-bs-target="#addSourceModal"
                        >Add Source</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
                <button
                    class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#collapseTwo"
                    aria-expanded="false"
                    aria-controls="collapseTwo"
                >Accordion Item #2</button>
            </h2>
            <div
                id="collapseTwo"
                class="accordion-collapse collapse"
                aria-labelledby="headingTwo"
                data-bs-parent="#accordionExample"
            >
                <div class="accordion-body">
                    <strong>This is the second item's accordion body.</strong> It is hidden by default, until the collapse plugin adds the appropriate classes that we use to style each element. These classes control the overall appearance, as well as the showing and hiding via CSS transitions. You can modify any of this with custom CSS or overriding our default variables. It's also worth noting that just about any HTML can go within the
                    <code>.accordion-body</code>, though the transition does limit overflow.
                </div>
            </div>
        </div>
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
                <button
                    class="accordion-button collapsed"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#collapseThree"
                    aria-expanded="false"
                    aria-controls="collapseThree"
                >Accordion Item #3</button>
            </h2>
            <div
                id="collapseThree"
                class="accordion-collapse collapse"
                aria-labelledby="headingThree"
                data-bs-parent="#accordionExample"
            >
                <div class="accordion-body">
                    <strong>This is the third item's accordion body.</strong> It is hidden by default, until the collapse plugin adds the appropriate classes that we use to style each element. These classes control the overall appearance, as well as the showing and hiding via CSS transitions. You can modify any of this with custom CSS or overriding our default variables. It's also worth noting that just about any HTML can go within the
                    <code>.accordion-body</code>, though the transition does limit overflow.
                </div>
            </div>
        </div>
    </div>

    <div class="mt-2">
        <button
            type="button"
            class="btn btn-primary w-100"
            data-bs-toggle="modal"
            data-bs-target="#addGroupModal"
        >Add Group</button>
    </div>

    <div class="mt-2">
        <button type="button" class="btn btn-danger w-100">Logout</button>
    </div>

    <!-- addSourceModal -->
    <div
        class="modal fade"
        id="addSourceModal"
        tabindex="-1"
        aria-labelledby="addSourceModal"
        aria-hidden="true"
    >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addSourceModal">Add Source</h5>
                    <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                        @click="refreshGroupSources"
                    ></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="input-group mb-3">
                            <span class="input-group-text" id="basic-addon1">Source name</span>
                            <input
                                type="text"
                                class="form-control"
                                placeholder="Source name"
                                aria-label="Source name"
                                aria-describedby="basic-addon1"
                                v-model="newSourceName"
                            />
                        </div>
                        <div class="input-group mb-3">
                            <span class="input-group-text" id="basic-addon1">RSS Feed URL</span>
                            <input
                                type="text"
                                class="form-control"
                                placeholder="Feed URL"
                                aria-label="Feed URL"
                                aria-describedby="basic-addon1"
                                v-model="newRssFeedUrl"
                            />
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal"
                        @click="refreshGroupSources"
                    >Close</button>
                    <button
                        type="button"
                        class="btn btn-primary"
                        @click="createSourceCallback"
                    >Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- addGroupModal -->
    <div
        class="modal fade"
        id="addGroupModal"
        tabindex="-1"
        aria-labelledby="addGroupModal"
        aria-hidden="true"
    >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addGroupModal">Add Group</h5>
                    <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Close"
                        @click="refreshGroupSources"
                    ></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="input-group mb-3">
                            <span class="input-group-text" id="basic-addon1">Group name</span>
                            <input
                                type="text"
                                class="form-control"
                                placeholder="Group name"
                                aria-label="Group name"
                                aria-describedby="basic-addon1"
                                v-model="newGroupName"
                            />
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal"
                        @click="refreshGroupSources"
                    >Close</button>
                    <button
                        type="button"
                        class="btn btn-primary"
                        @click="createGroupCallback"
                    >Save changes</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "SideMenu",
    data() {
        return {
            newGroupName: "",
            newSourceName: "",
            newRssFeedUrl: "",
        }
    },
    methods: {
        changeMe(el) {
            console.log(el.id);
        },
        createGroupCallback() {
            this.createGroup();
        },
        createSourceCallback() {
            this.createSource();
        },
        createGroup() {
            console.log("create new group on remote: " + this.newGroupName);
            this.newGroupName = "";
        },
        createSource() {
            console.log("create new source on remote: " + this.newSourceName);
            this.newSourceName = "";
            this.newRssFeedUrl = "";
        },
        fetchGroups() {
            console.log("fetch all groups and sources from remote!");
        },
        refreshGroupSources() {
            this.fetchGroups();
        }
    },
    mounted() {
        this.fetchGroups();
    },
};
</script>