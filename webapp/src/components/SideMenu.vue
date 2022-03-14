<template>
    <h4>Groups</h4>
    <!-- @click="changeMe($event.currentTarget)" -->
    <ol class="list-group list-group-numbered">
        <li class="list-group-item d-flex justify-content-between align-items-start">
            <div class="ms-2 me-auto">
                <div class="fw-bold">Subheading</div>
                <div>Content for list item</div>
                <div>Content for list</div>
            </div>
            <span class="badge bg-primary rounded-pill">14</span>
        </li>
        <li class="list-group-item d-flex justify-content-between align-items-start">
            <div class="ms-2 me-auto">
                <div class="fw-bold">Subheading</div>Content for list item
            </div>
            <span class="badge bg-primary rounded-pill">14</span>
        </li>
        <li class="list-group-item d-flex justify-content-between align-items-start">
            <div class="ms-2 me-auto">
                <div class="fw-bold">Subheading</div>Content for list item
            </div>
            <span class="badge bg-primary rounded-pill">14</span>
        </li>
    </ol>
</template>

<script>
export default {
    name: "SideMenu",
    methods: {
        changeMe(el) {
            console.log(el.id);
        }
    },
};
</script>